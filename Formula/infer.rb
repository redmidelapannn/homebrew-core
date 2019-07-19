class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.16.0",
      :revision => "4a91616390c058382c703f47653adfaecd31a7d7"

  bottle do
    cellar :any
    sha256 "06d238c14262027c945db508221fc7793271e0c94b44e5ba072cb249f7d19086" => :mojave
    sha256 "5b190be9b99c5377beab74a78715ed7208bf0521eb6af7b6116cb8b306762bb2" => :high_sierra
    sha256 "4a2869a9df06e706a7179d02e20777f189161f9eb4d8a82817684e9fede2d942" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on :java => ["1.8", :build, :test]
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"
  depends_on "sqlite"

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib/"pkgconfig"

    # opamroot = HOMEBREW_CACHE/"opam"
    opamroot = libexec/"opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # explicitly build the clang before infer's configure
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --with-fcp-clang"

    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "@IS_RELEASE_TREE@", "yes"

    llvm_args = %w[
      -DLLVM_INSTALL_UTILS=OFF
      -DLIBOMP_ARCH=x86_64
    ]

    inreplace "facebook-clang-plugins/clang/setup.sh", "CMAKE_ARGS=(", "CMAKE_ARGS=(\n  " + llvm_args.join("\n  ")

    # setup opam (disable opam sandboxing, since it will otherwise fail inside homebrew sandbox)
    # disabling sandboxing inside a sandboxed environment is necessary as of opam 2.0
    inreplace "build-infer.sh", "--no-setup", "--no-setup --disable-sandboxing"
    # prefer system bins configuring opam dependency mlgmpidl (needs to use system clang+ranlib+libtool)
    # if some homebrew versions of these mix with system tools, it can break compilation
    inreplace "build-infer.sh", "opam install", "PATH=/usr/bin:$PATH\n    opam install"

    pathfix_lines = [
      "export SDKROOT=#{MacOS.sdk_path}",
      "eval $(opam env)",
    ]

    # need to set sdkroot for clang to see certain system headers
    inreplace "build-infer.sh", "./configure $INFER_CONFIGURE_OPTS",
        pathfix_lines.join("\n") + "\n./configure $INFER_CONFIGURE_OPTS"

    # build ocaml dependecies first so custom clang will build with ocaml bindings. then build+install infer
    system "./build-infer.sh", "--only-setup-opam", "--yes"
    system "opam", "config", "exec", "--", "facebook-clang-plugins/clang/setup.sh"
    system "./build-infer.sh", "all", "--yes"
    system "opam", "config", "exec", "--", "make", "install"

    # opam switches contain lots of files for end-user usage
    # much can be removed if all we need is a package
    opam_switch = File.read("build-infer.sh").match(/INFER_OPAM_DEFAULT_SWITCH=\"([^\"]+)\"/)[1]
    cd libexec/"opam" do
      # remove everything but the opam switch used for infer
      rm_rf Dir["*"] - [opam_switch.to_s]

      # remove everything in the switch but the dylibs infer needs during runtime
      cd opam_switch.to_s do
        rm_rf Dir["*"] - ["share"]

        cd "share" do
          rm_rf Dir["*"] - ["apron", "elina"]
        end
      end
    end
  end

  test do
    shell_output("javac -version")
    shell_output("which javac")
    (testpath/"FailingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c")

    (testpath/"FailingTest.java").write <<~EOS
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<~EOS
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java")
    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
  end
end

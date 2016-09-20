class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.1.tar.gz"
  sha256 "52beafc9d78fc315115226f31425e21df1714d96c7dfcdeeb02306e2fe028dd8"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb632fd7fa62a6597f2fa2dbedcafa7117a2dc9db9d7f2f4639fa3baf5a00a40" => :sierra
    sha256 "2fff8f4503897771d765ffd49f9bcf36fc43e24f67073fd8d664d89638be34c6" => :el_capitan
    sha256 "6086c3ad2d8427596819c20a64af0f863182b96fd503d1112640c03436d74d81" => :yosemite
  end

  depends_on java: "1.8+"
  depends_on macos: :yosemite

  def install
    # Works around "Error: couldn't connect to server"
    # Upstream issue 13 Sep 2016 https://github.com/bazelbuild/bazel/issues/1767
    if MacOS.version == :sierra
      inreplace "src/main/cpp/blaze.cc", "for (int ii = 0; ii < 600; ++ii) {",
                                         "for (int ii = 0; ii < 60000; ++ii) {"
    end

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end

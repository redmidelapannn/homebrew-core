class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.7",
      :revision => "bb7b827a9c135fbfd066da94109a728351b87b92"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6e5d4942d9a3e1527ccca6283b361556dfc9ea2fb66c96e681b1f7e139955052" => :high_sierra
    sha256 "c74abdd7b1f017682b52547093bbe30af290c408854869a072de281cb7f493b0" => :sierra
    sha256 "2062705a0fb5bf6075206b1b6ce622a4f8aac49cfe74cfef08c172459045852a" => :el_capitan
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

    depends_on "aspcud" => :build
    depends_on "opam" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

    # Build requires targets to be built in specific order
    ENV.deparallelize

    if build.head?
      Dir.mktmpdir("opamroot") do |opamroot|
        ENV["OPAMROOT"] = opamroot
        ENV["OPAMYES"] = "1"
        system "opam", "init", "--no-setup"
        system "opam", "config", "exec", "--",
               "opam", "pin", "add", "haxe", buildpath, "--no-action"
        system "opam", "config", "exec", "--",
               "opam", "install", "haxe", "--deps-only"
        system "opam", "config", "exec", "--",
               "make", "ADD_REVISION=1"
      end
    else
      system "make", "OCAMLOPT=ocamlopt.opt"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", "."
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats; <<~EOS
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
    system "#{bin}/haxelib", "version"
  end
end

class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.2",
      :revision => "890f8c70cf23ce6f9fe0fdd0ee514a9699433ca7"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c6407d03666c53223dc7ce524180bb1ee44d300e5f052afe5d103b42fc652025" => :sierra
    sha256 "ab6142dabb8c9a2dfd5e7b22adcac57245375fe313fadc5827134a629a6ab0d1" => :el_capitan
    sha256 "ac45382ee8b0939223ba1794a490221b0fe9a86436d6e10f67deb397e7133623" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    args = ["OCAMLOPT=ocamlopt.opt"]
    args << "ADD_REVISION=1" if build.head?
    system "make", *args

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", "."
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  def caveats; <<-EOS.undent
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

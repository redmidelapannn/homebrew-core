class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.2",
      :revision => "890f8c70cf23ce6f9fe0fdd0ee514a9699433ca7"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "512821b5677cdce41c9adefc26b540a96c70a61efea261a7b6aa6cbb14ff2699" => :sierra
    sha256 "c4897bb97b348eb55774e6f3f8a6297e904a6d1fc7486faae61c61be477032ee" => :el_capitan
    sha256 "889bfdf85a8c5ffc57befeb52c52c6147886c947657274d4a0d21dc3d5854c92" => :yosemite
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
    depends_on "opam" => :build

    # ptmap 2.0.2 is needed for OCaml 4.05.0 compatibility
    # See https://github.com/backtracking/ptmap/pull/4
    resource "ptmap" do
      url "https://github.com/ocaml/opam-repository/pull/10170.diff?full_index=1"
      sha256 "2d5394638c370e654ee1b87e23a348d512da717df9bd52a16c1816c6047ba4f7"
    end
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    if build.head?
      ENV["OPAMROOT"] = buildpath/"opamroot"
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--no-setup"
      buildpath.install resource("ptmap")
      system "patch", "-p1", "-i", buildpath/"10170.diff", "-d",
                      "opamroot/repo/default"
      inreplace "opamroot/repo/default/packages/ptmap/ptmap.2.0.2/opam",
                /"obuild" {build}/, "\\0\n  \"qcheck\" {build & >= \"0.7\"}"
      system "opam", "update"
      system "opam", "config", "exec", "--", "opam", "install", "ocamlfind",
             "sedlex", "xml-light", "extlib", "rope", "ptmap>2.0.1"
      system "opam", "config", "exec", "--", "make", "ADD_REVISION=1"
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

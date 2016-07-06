class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git", :tag => "3.2.1", :revision => "deab4424399b520750671e51e5f5c2684e942c17"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e845ab8cf39bb8d54b5f4e1e0e0eb4fbf7db327a5644180fda8a00c02a4a5b83" => :el_capitan
    sha256 "da03a04be412cc720b1f809c95fe50b24208f9274bdea8b4f42d8498235148c7" => :yosemite
    sha256 "b1216196146173543b3e2497da010552f3b459c4136c91dd9b65882c51a995ca" => :mavericks
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "neko"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    args = ["OCAMLOPT=ocamlopt.opt"]
    args << "ADD_REVISION=1" if build.head?
    system "make", *args
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
  end
end

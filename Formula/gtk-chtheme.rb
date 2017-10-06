class GtkChtheme < Formula
  desc "GTK+ 2.0 theme changer GUI"
  homepage "http://plasmasturm.org/code/gtk-chtheme/"
  url "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2"
  sha256 "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d8d3fc5a7584aa958a27c97081bb9019e2de2b0d2f3ae247a20230cf8cd4ab48" => :high_sierra
    sha256 "4586f283f93c8bd5a26f713f679c6043a206eb330b10d9a8bdfae4b49532dba4" => :sierra
    sha256 "0e0c04b9c557a0714438c684cf2d8fc2cd0396a819494e1a14f3ded6d305ec66" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    # Unfortunately chtheme relies on some deprecated functionality
    # we need to disable errors for it to compile properly
    inreplace "Makefile", "-DGTK_DISABLE_DEPRECATED", ""

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # package contains just an executable and a man file
    # executable accepts no options and just spawns a GUI
    assert_predicate bin/"gtk-chtheme", :exist?
  end
end

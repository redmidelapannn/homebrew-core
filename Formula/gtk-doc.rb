class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.30/gtk-doc-1.30.tar.xz"
  sha256 "a4f6448eb838ccd30d76a33b1fd095f81aea361f03b12c7b23df181d21b7069e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eaf407005e3aeadf5d62aff92e8eb1a381c723f94197eddee72a612c2f062770" => :mojave
    sha256 "eaf407005e3aeadf5d62aff92e8eb1a381c723f94197eddee72a612c2f062770" => :high_sierra
    sha256 "e6fd3145fe864cae1b2f04a7529685c9a5ab0abf68d2155982d92d0ec4865b2f" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "python"
  depends_on "source-highlight"
  uses_from_macos "libxslt"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/1d/55/55cd82a72af652d71eb14f318e2d12d2fd14ded43d6fd105e50ed395198c/Pygments-2.4.0.tar.gz"
    sha256 "31cba6ffb739f099a85e243eff8cb717089fdd3c7300767d9fc34cb8e1b065f5"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("Pygments").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-highlight=source-highlight",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end

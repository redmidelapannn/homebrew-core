class Terminator < Formula
  desc "Multiple terminals in one window"
  homepage "https://gnometerminator.blogspot.com/p/introduction.html"
  revision 2
  head "lp:terminator", :using => :bzr

  stable do
    url "https://launchpad.net/terminator/trunk/0.98/+download/terminator-0.98.tar.gz"
    sha256 "0a6d8c9ffe36d67e60968fbf2752c521e5d498ceda42ef171ad3e966c02f26c1"

    # Patch to fix cwd resolve issue for OS X / Darwin
    # See: https://bugs.launchpad.net/terminator/+bug/1261293
    # Should be fixed in next release after 0.98
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/terminator/0.98.patch"
      sha256 "fe933cba5bbfa31c6fae887010c5c2298371c93f5b78a10d8d43341c3302abb7"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f6f2045be8d1e3a6308967923f85fbd7d4c2abf974db5449d3a4f06ec921ea67" => :catalina
    sha256 "f6f2045be8d1e3a6308967923f85fbd7d4c2abf974db5449d3a4f06ec921ea67" => :mojave
    sha256 "f6f2045be8d1e3a6308967923f85fbd7d4c2abf974db5449d3a4f06ec921ea67" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on "python@2"
  depends_on "vte"

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(prefix)
  end

  def post_install
    system "#{Formula["gtk"].opt_bin}/gtk-update-icon-cache", "-f",
           "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    ENV.prepend_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "#{bin}/terminator", "--version"
  end
end

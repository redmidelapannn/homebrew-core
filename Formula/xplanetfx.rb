class Xplanetfx < Formula
  desc "Configure, run or daemonize xplanet for HQ Earth wallpapers"
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.6.12_all.tar.gz"
  version "2.6.12"
  sha256 "42b84623821032b7f31797d0187e9e0e298282831327fe3fc508dd1d85c493a7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c79c600bb45c1f74c1a6796de0319be8e0a77872edea8da9be55f90e19a11b58" => :sierra
    sha256 "c79c600bb45c1f74c1a6796de0319be8e0a77872edea8da9be55f90e19a11b58" => :el_capitan
    sha256 "c79c600bb45c1f74c1a6796de0319be8e0a77872edea8da9be55f90e19a11b58" => :yosemite
  end

  option "without-gui", "Build to run xplanetFX from the command-line only"
  option "with-gnu-sed", "Build to use GNU sed instead of macOS sed"

  depends_on "xplanet"
  depends_on "imagemagick"
  depends_on "wget"
  depends_on "coreutils"
  depends_on "gnu-sed" => :optional

  if build.with? "gui"
    depends_on "librsvg"
    depends_on "pygtk" => "with-libglade"
  end

  skip_clean "share/xplanetFX"

  def install
    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    prefix.install "bin", "share"

    path = "#{Formula["coreutils"].opt_libexec}/gnubin"
    path += ":#{Formula["gnu-sed"].opt_libexec}/gnubin" if build.with?("gnu-sed")
    if build.with?("gui")
      ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
      ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
    bin.env_script_all_files(libexec+"bin", :PATH => "#{path}:$PATH", :PYTHONPATH => ENV["PYTHONPATH"], :GDK_PIXBUF_MODULEDIR => ENV["GDK_PIXBUF_MODULEDIR"])
  end

  def post_install
    if build.with?("gui")
      # Change the version directory below with any future update
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
      system "#{HOMEBREW_PREFIX}/bin/gdk-pixbuf-query-loaders", "--update-cache"
    end
  end

  test do
    system "#{bin}/xplanetFX", "--help"
  end
end

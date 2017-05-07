class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.3.tar.xz"
  sha256 "669b7d78ad98390a762eec50d7cc637e25f196d986c0200d9f1c3a0e0cd90f33"

  bottle do
    rebuild 1
    sha256 "ff4c4e2ec4d9c21087a4bdd962a6ebbc66bdfe7b04df2c87c57a23179908f112" => :sierra
    sha256 "4ff7d9c453cbc3d83dacff9ff2e96afe81cf8764bf291142a2db3824f5669231" => :el_capitan
    sha256 "a91ea99829c1e9894df2cfba91e33cd495eed951ed8be119fd9638786e6814cc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  needs :cxx11

  resource "mozjs38" do
    url "https://archive.mozilla.org/pub/firefox/releases/38.8.0esr/source/firefox-38.8.0esr.source.tar.bz2"
    sha256 "9475adcee29d590383c4885bc5f958093791d1db4302d694a5d2766698f59982"
  end

  def install
    resource("mozjs38").stage do
      inreplace "config/rules.mk", "-install_name @executable_path/$(SHARED_LIBRARY) ", "-install_name #{lib}/$(SHARED_LIBRARY) "
      cd("js/src") do
        ENV["PYTHON"] = "python"
        inreplace "configure", "'-Wl,-executable_path,$(LIBXUL_DIST)/bin'", ""
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--with-system-zlib",
                              "--with-system-icu",
                              "--enable-system-ffi",
                              "--enable-readline",
                              "--enable-shared-js",
                              "--enable-threadsafe"
        system "make"
        system "make", "install"
        rm Dir["#{bin}/*"]
      end
      mv "#{lib}/pkgconfig/js.pc", "#{lib}/pkgconfig/mozjs-38.pc"
      # headers were installed as softlinks, which is not acceptable
      cd(include.to_s) do
        `find . -type l`.chomp.split.each do |link|
          header = File.readlink(link)
          rm link
          cp header, link
        end
      end
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      # remove mozjs static lib
      rm "#{lib}/libjs_static.ajs"
    end
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-dbus-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end

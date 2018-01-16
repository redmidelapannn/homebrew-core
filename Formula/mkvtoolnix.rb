class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-20.0.0.tar.xz"
  sha256 "6f4b86a16af1f979ce2e83e64223b1bb8635ac8f81863d8ce46014a82c8bf500"

  bottle do
    rebuild 1
    sha256 "b0615494175d3db163edf45e62a5cdd645308d118cdc7ca7cf9b8fff8b6dcb24" => :high_sierra
    sha256 "192e379317614c7110b0e2f17c3ccaa98a48aac6a3ed4d2ec4af18d69350f6b2" => :sierra
    sha256 "22032508a9b1f310ec8462a04b7e8993565130c1745bb8dca78dc01cb3b67884" => :el_capitan
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-qt", "Build with Qt GUI"

  deprecated_option "with-qt5" => "with-qt"

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "ruby" => :build if MacOS.version <= :mountain_lion
  depends_on "boost"
  depends_on "libebml"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "flac" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "gettext" => :optional
  depends_on "qt" => :optional
  depends_on "cmark" if build.with? "qt"

  needs :cxx11

  def install
    ENV.cxx11

    features = %w[libogg libvorbis libebml libmatroska]
    features << "flac" if build.with? "flac"
    features << "libmagic" if build.with? "libmagic"

    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes.chop!
    extra_libs.chop!

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
      --with-extra-includes=#{extra_includes}
      --with-extra-libs=#{extra_libs}
    ]

    if build.with?("qt")
      qt = Formula["qt"]

      args << "--with-moc=#{qt.opt_bin}/moc"
      args << "--with-uic=#{qt.opt_bin}/uic"
      args << "--with-rcc=#{qt.opt_bin}/rcc"
      args << "--enable-qt"
    else
      args << "--disable-qt"
    end

    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<~EOS
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end

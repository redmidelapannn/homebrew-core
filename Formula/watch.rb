class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag      => "v3.3.15",
      :revision => "7bb949bcba13c107fa0f45d2d0298b1ad6b6d6cc"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0f49bba2b6683fd8ac9f11b929239822fc85aa1d94954be7d548d2531143ad5b" => :mojave
    sha256 "585605c36e7fb5f2a1a0c409ac06c21ebd0bbe15f92ee43faf1e8947c0da546a" => :high_sierra
    sha256 "931690ad8da7bfacb8aac97b6b36b6af5607ef572d1f4ec803d4ed4e037155c6" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ncurses" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "echo", "\"%s/\\\\(CURSES_LIB=ncurses\\\\)w/\\\\1/\\nwq\"", "|", "ed -s configure"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end

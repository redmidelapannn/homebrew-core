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
    sha256 "fd390d9f72b680c4a2313bb9b3f7b2010bf81b2eb438406c9d20634f95c6266d" => :mojave
    sha256 "421a31880beb0e91a6efa9896aa0cfb628554d561d94fb79ea052950f0a2121b" => :high_sierra
    sha256 "125e4993e2c55a6391386ba56e02a208d160cb4ba3615a010b755093533df564" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

  def install
    ENV["NCURSESW_CFLAGS"] = "#{Formula["ncurses"].include} #{Formula["ncurses"].include}/ncursesw"
    ENV["NCURSESW_LIBS"] = "#{Formula["ncurses"].lib} -lncursesw"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end

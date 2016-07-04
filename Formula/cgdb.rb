class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.6.8.tar.gz"
  sha256 "be203e29be295097439ab67efe3dc8261f742c55ff3647718d67d52891f4cf41"

  bottle do
    revision 1
    sha256 "f13d8d6c19bf933fe54e339edde7f72a6468415f1f8e904e05b5368598bbdc16" => :el_capitan
    sha256 "9f6a03347bb68cc6bfbf90c632d5cdf6aab7d072008cb69b729d190dac032a4b" => :yosemite
    sha256 "6b4a86d7edbdd4d243b20bb7c7da392b43e25e4886793c0633cb4e2cc908f117" => :mavericks
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end

class Chromaterm < Formula
  desc "Colorize your terminal's output using RegEx"
  homepage "https://github.com/hSaria/ChromaTerm--"
  url "https://github.com/hSaria/ChromaTerm--/archive/0.3.4.tar.gz"
  sha256 "9e7d3b5884357fbb7b89b307769652a61358b45849215fd8484255c3f98f9203"

  bottle do
    cellar :any
    sha256 "8b621004a837ebfbdcd678cb123f2ce7a5602bbc5cdcaabe4eb5c21186ef2e22" => :mojave
    sha256 "6cf596e7914e2f076fc6a6a2af595317b8bde2386525f2c762da24237eaa5aa5" => :high_sierra
    sha256 "032da326640239747782be789f4b7c11e2cbe825e5bcc1a99464f9b585bd0eaa" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    Dir.chdir "src/"
    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "ct"
    man1.mkpath
    man1.install "../ct.1"
  end

  test do
    system "#{bin}/ct", "-d"
  end
end

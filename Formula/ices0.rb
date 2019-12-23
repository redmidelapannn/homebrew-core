class Ices0 < Formula
  desc "Source client for broadcasting to Icecast/Shoutcast servers in MP3 format"
  homepage "https://github.com/Moonbase59/ices0"
  url "https://github.com/Moonbase59/ices0/archive/v0.4.11.tar.gz"
  sha256 "9179496149e763a75fea37bf6ec12947cad4bdb868b401d34728b353b836047a"
  head "https://github.com/Moonbase59/ices0.git"

  bottle do
    sha256 "f019b543d137eee9a81cb9480019c528edd7753e66037ab025b0a760b5d498d8" => :catalina
    sha256 "a463e7beb00b40e394c1f1562db07bb8db5ed2d2bfb7f634fdaeacb043310bc2" => :mojave
    sha256 "897ab110fafc48363db181685725338e21203380b75c35d95a5de8c9b60a2ce6" => :high_sierra
  end

  # building
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # input/output
  depends_on "faad2"
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "libxml2"
  depends_on "mp4v2"

  def install
    system "aclocal"
    system "autoreconf", "-fi"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # For Homebrew/homebrew-core this will need to be a test that verifies
    # the functionality of the software. Run the test with `brew test loudgain`.
    # Options passed to `brew install` such as `--HEAD` also need to be
    # provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # assert_match /^loudgain\s+#{version}.*/,
    assert_match /^ices\s+0\.4\.11.*/,
      shell_output("#{bin}/ices -V").strip
  end
end

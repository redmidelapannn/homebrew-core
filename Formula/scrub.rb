class Scrub < Formula
  desc "Writes patterns on magnetic media to thwart data recovery"
  homepage "https://code.google.com/archive/p/diskscrub/"
  url "https://github.com/chaos/scrub/releases/download/2.6.1/scrub-2.6.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/scrub/scrub_2.6.1.orig.tar.gz"
  sha256 "43d98d3795bc2de7920efe81ef2c5de4e9ed1f903c35c939a7d65adc416d6cb8"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a281a0a8ddb9ab23960b06926c5641ffc519d6aa571b48fae544a9ceaf49a2ba" => :mojave
    sha256 "8280c122ac4b687345354c7b37c2598832286791a340822e9a3935a8e364bb6b" => :high_sierra
    sha256 "db94d791fb3132f4add120442464d107dea60265d55470c1551d7137ef08e533" => :sierra
  end

  head do
    url "https://github.com/chaos/scrub.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo.txt"
    path.write "foo"

    output = shell_output("#{bin}/scrub -r -p dod #{path}")
    assert_match "scrubbing #{path}", output
    refute_predicate path, :exist?
  end
end

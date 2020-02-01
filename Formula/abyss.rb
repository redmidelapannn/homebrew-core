class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/gsc-software-centre"
  url "https://github.com/bcgsc/abyss/releases/download/2.2.4/abyss-2.2.4.tar.gz"
  sha256 "f064a8c5ad152a37963d9001df6c89d744370f7ec5a387307747c4647360a47c"

  bottle do
    cellar :any
    sha256 "105f24f7496ce63c29ce7919f85569d7fc3e67a61cb3f35404adf394efcb98a4" => :catalina
    sha256 "1aeeff414e3ba6f94ee0ff4b08a2bc9e98b2e32d9bd93a39bf73bfdc65bcda28" => :mojave
    sha256 "bfc7b22cd195fcdd39553d215ce5b863171590ded76551e5a00ecfbc147ef578" => :high_sierra
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  fails_with :clang # no OpenMP support

  resource("testdata") do
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version >= :mojave && MacOS::CLT.installed?
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-maxk=128",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    testpath.install resource("testdata")
    system "#{bin}/abyss-pe", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end

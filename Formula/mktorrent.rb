class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://mktorrent.sourceforge.io/"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "23fd00cfec9cc011df349a8ba669826c191ff3e76d815234c5e2eb5717c88145" => :sierra
    sha256 "08a7b22584060fd56ca0bc4a680e650de1ec77b502145a5e7f862d307205fb86" => :el_capitan
    sha256 "07ed1709532ff5c788a000363e383ab7bf5ab1af4d7cd00fd1fa5e115f17bcb3" => :yosemite
  end

  depends_on "openssl"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      Injustice anywhere is a threat to justice everywhere.
    EOS

    system bin/"mktorrent", "-d", "-c", "Martin Luther King Jr", "test.txt"
    assert_predicate testpath/"test.txt.torrent", :exist?, "Torrent was not created"

    file = File.read(testpath/"test.txt.torrent")
    output = file.force_encoding("ASCII-8BIT") if file.respond_to?(:force_encoding)
    assert_match "Martin Luther King Jr", output
  end
end

class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://github.com/Rudde/mktorrent/wiki"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e81d31f8303befa463ed7e00df15623a93babd4fadd66efe2b34b7fe84ce6998" => :mojave
    sha256 "241386f30ce4caa5e2d68901542c1ae23739cb38742ce0986ba506c7c89b4d1c" => :high_sierra
    sha256 "6cec953cbc9694943bcfe47c6d6fe751c4db710e76886a46fd1d9958a9f5e9b3" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Injustice anywhere is a threat to justice everywhere.
    EOS

    system bin/"mktorrent", "-d", "-c", "Martin Luther King Jr", "test.txt"
    assert_predicate testpath/"test.txt.torrent", :exist?, "Torrent was not created"

    file = File.read(testpath/"test.txt.torrent")
    output = file.force_encoding("ASCII-8BIT") if file.respond_to?(:force_encoding)
    assert_match "Martin Luther King Jr", output
  end
end

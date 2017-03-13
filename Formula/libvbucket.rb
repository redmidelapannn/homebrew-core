class Libvbucket < Formula
  desc "Utility library providing mapping to virtual buckets"
  homepage "https://couchbase.com/develop/c/current"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz"
  sha256 "398ba491d434fc109fd64f38678916e1aa19c522abc8c090dbe4e74a2a2ea38d"

  bottle do
    cellar :any
    rebuild 2
    sha256 "80e63bb8de1486826a65895fd3a9b64daa56a80f3635047d5cb9f0bb09963aee" => :sierra
    sha256 "af03ba478676d238085f4bd8fd93f70e80b02bc57d9831816510b68eecff779e" => :el_capitan
    sha256 "917658bff797a99170d2545ca984ba58063b0582bd317aeccd3e19601ad1b3b0" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-docs"
    system "make", "install"
  end

  test do
    json = JSON.generate(
      "hashAlgorithm" => "CRC",
      "numReplicas" => 2,
      "serverList" => ["server1:11211", "server2:11210", "server3:11211"],
      "vBucketMap" => [[0, 1, 2], [1, 2, 0], [2, 1, -1], [1, 2, 0]],
    )

    expected = <<-EOS.undent
      key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
      key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
      EOS

    output = pipe_output("#{bin}/vbuckettool - hello world", json)
    assert_equal expected, output
  end
end

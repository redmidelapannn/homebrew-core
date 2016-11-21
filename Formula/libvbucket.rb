class Libvbucket < Formula
  desc "Utility library providing mapping to virtual buckets"
  homepage "https://couchbase.com/develop/c/current"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz"
  sha256 "398ba491d434fc109fd64f38678916e1aa19c522abc8c090dbe4e74a2a2ea38d"

  bottle do
    cellar :any
    rebuild 2
    sha256 "edc56f7dad11be99ff52bfbd6733073f1aef9d8420ab6d9747ef0eb0ee00224d" => :sierra
    sha256 "ddf593bc1e97e85ff06e99717b81058fc969841391a8e7fbb1e1eec01750307e" => :el_capitan
    sha256 "fb8e8d2097c55ead56ccc12081ce4802f77bd3107e454b2bd5e287927a34ea5c" => :yosemite
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
      "vBucketMap" => [[0, 1, 2], [1, 2, 0], [2, 1, -1], [1, 2, 0]]
    )

    expected = <<-EOS.undent
      key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
      key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
      EOS

    output = pipe_output("#{bin}/vbuckettool - hello world", json)
    assert_equal expected, output
  end
end

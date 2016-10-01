class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.1/cpp/avro-cpp-1.8.1.tar.gz"
  sha256 "6559755ac525e908e42a2aa43444576cba91e522fe989088ee7f70c169bcc403"
  revision 1

  bottle do
    cellar :any
    sha256 "fc1a65af4ce532ade1a376ba678a2e0e67099475e761b82ee34432b8ab511157" => :sierra
    sha256 "eab3fb0f328cc188607f22641fcbdc7960ef7c3648cce8e9fcedd44ada1bfe36" => :el_capitan
    sha256 "c0a7bcea8d00e9900c10e5e4c42bedfe1569dbacf6124951cf7269e042925d21" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "boost@1.61"

  def install
    # Avoid deprecated macros removed in Boost 1.59.
    # https://issues.apache.org/jira/browse/AVRO-1719
    inreplace "test/SchemaTests.cc", "BOOST_CHECKPOINT(", "BOOST_TEST_CHECKPOINT("
    inreplace "test/buffertest.cc", "BOOST_MESSAGE(", "BOOST_TEST_MESSAGE("

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

class Cockatrice < Formula
  desc "Cross-platform virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-11-19-Release-2.4.0",
      :revision => "4d641eb0e723bf4f83343a3b3c6650a1008793f8"
  version "2.4.0"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    rebuild 1
    sha256 "13116f90546088816a7bb05b79def2cd9a36b8f97da9264e57ae5726c250c4e7" => :high_sierra
    sha256 "2ecf5cbb1c8bb01167de1f311c08b60ce71142b3a6294d99ef974dd022b64491" => :sierra
    sha256 "3ca71a38071d75fac872452f3e5323fc3dea79c0efdcf524bfb1592a53aebbae" => :el_capitan
  end

  depends_on :macos => :el_capitan
  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "qt@5.7"

  fails_with :clang do
    build 503
    cause "Undefined symbols for architecture x86_64: google::protobuf"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      prefix.install Dir["release/*.app"]
    end
  end

  test do
    assert_predicate prefix/"cockatrice.app/Contents/MacOS/cockatrice", :executable?
    assert_predicate prefix/"oracle.app/Contents/MacOS/oracle", :executable?
  end
end

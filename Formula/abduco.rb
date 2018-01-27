class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  head "https://github.com/martanne/abduco.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "32122cc75fefcd40d9f4128208f5b9f63d6cdb2b619d2cc67c5b5d0b6e23f8bb" => :high_sierra
    sha256 "f70d978da0e99c3e84fe85fc9f9a4afe38d39e775626cb10751e936c0b56c4c4" => :sierra
    sha256 "bf030604a7baadc1a7a2c2b4341c6ecbb223255baf3a87c21360d87372113325" => :el_capitan
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^abduco-#{version}/, result
  end
end

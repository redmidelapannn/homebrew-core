class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  head "http://repo.or.cz/abduco.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "70d5ae1972b4e2a10545a6ddcc49f670b42592789fe00c55a54019111ce7f660" => :high_sierra
    sha256 "c9cd2b1cd23329defb287d96a104de088b87bb9dc5e01aea29d99d578fda830f" => :sierra
    sha256 "fffe90fda2f4f2d3b32e8ec5b7aa186fc45653a6c1a9b3aeca203a00e4e7d127" => :el_capitan
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

class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "https://www.brain-dump.org/projects/abduco"
  url "https://github.com/martanne/abduco/releases/download/v0.6/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  head "https://github.com/martanne/abduco.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0715a5dccb9b41a4c840452a37486b405a0da9ff7c28bce557fc2e00acfef435" => :catalina
    sha256 "da00a0adee8ecc588b531180f69f37bf4251b3f32d4808175483c654f816736c" => :mojave
    sha256 "0b22853be63e4f4793b2faa650f9605cb67c4b543b36d25fa619e801b64dcb43" => :high_sierra
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

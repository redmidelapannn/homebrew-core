class Kbcb < Formula
  desc "Afilitates developers to connect their projects to Kambria codebase"
  homepage "https://app.kambria.io"
  url "https://github.com/kambria-platform/kbcb/raw/develop/packages/mac/kbcb-0.0.1/kbcb-0.0.1.tar.gz"
  sha256 "208b5a98bde93f77ba2f0ccd5a5a2315fe607f43c243cc29a51a561689cd45e0"

  bottle do
    sha256 "515406fc03199cd5546e637e8ae90e1828611d700553eeb85218f4b776c63690" => :mojave
    sha256 "ccd32edb81338eaa8ab4f0b078acadff6ceab8b2ce7c7ce21c5ce6d06085df05" => :high_sierra
    sha256 "2ff6182a71afc50042510f2571b0cb154d03401d580df745c6a6eaae9de162eb" => :sierra
  end

  depends_on "cmake" => :build

  def install
    rm_rf("build")
    mkdir("build")
    Dir.chdir("./build") do
      system "cmake", "..", "-DENV=\"PRODUCTION\"", "-DSHARED=\"/usr/local/Cellar/kbcb/#{version}/share/pre-push\""
      system "make"
    end
    bin.install "build/kbcb"
    share.install "src/hooks/pre-push"
  end

  test do
    help = `kbcb --help`
    assert_not_equal nil, help
    shared_data = `kbcb get-dir --pre-push`
    assert_equal shared_data, "/usr/local/Cellar/kbcb/#{version}/share/pre-push\n"
  end
end

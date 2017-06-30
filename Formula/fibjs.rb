class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.6.1/fullsrc.zip"
  sha256 "30959d2c87543cb9ade38b931de04947811e5ab74967ac8c8abadca3d8d47a12"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1ef46bfc582f4bf72a3599b8d6b5a999492026ee2a4722b2a4ef5f9371031df3" => :sierra
    sha256 "a72b28995e924d58cbbf4eb9239701db2b68497aa6a19aa0edc9a67b73ccca8e" => :el_capitan
    sha256 "e0d70a7c801b9b989fe1e59490e6d69e8ad5dcb7f4954e854862089e693c9e04" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    # the build script breaks when CI is set by Homebrew
    begin
      env_ci = ENV.delete "CI"
      system "./build", "release", "-j#{ENV.make_jobs}"
    ensure
      ENV["CI"] = env_ci
    end

    bin.install "bin/Darwin_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end

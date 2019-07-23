class Flat < Formula
  desc "Flattens json or yaml structure"
  homepage "https://github.com/tlopo-ruby/flat"
  url "https://github.com/tlopo-ruby/flat.git", :using => :git, :revision => "bde2c6e47d055f7c7f27c06d6438bc2a6a6e3967"
  version "0.0.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "355ca4b49b912e96107c87f48685d5bf15981b364de2e2fbed4863fcbec6ddf0" => :mojave
    sha256 "355ca4b49b912e96107c87f48685d5bf15981b364de2e2fbed4863fcbec6ddf0" => :high_sierra
    sha256 "663a0a22ed623e94e7a890747b3c46a947ae541fb0a86f119db5a8df6f9aba8d" => :sierra
  end

  def install
    mv "flat.rb", "flat"
    bin.install "flat"
  end

  test do
    assert_match "Usage: flat", shell_output("#{bin}/flat --help")
  end
end

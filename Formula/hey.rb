class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey.git",
    :tag      => "v0.1.2",
    :revision => "01803349acd49d756dafa2cb6ac5b5bfc141fc3b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4f07ea0764c980fabd4d89badc24a9049a48e1675362dd60b6a8e15517d4b359" => :mojave
    sha256 "d67f529ffda55afb1fdb3793123fad2672d33c24d118224d7feec7ece5f60856" => :high_sierra
    sha256 "e3a450586e62ab3b82bdb75bbcd9dcd3cd1d55ade38a84574a98f87dbeacc936" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/rakyll/hey"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"hey"
      prefix.install_metafiles
    end
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end

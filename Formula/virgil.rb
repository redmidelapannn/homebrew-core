class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.0.1",
     :revision => "03ddee65e9cecbdd7ef55b1285c0ca70758d6d40"
  head "https://github.com/VirgilSecurity/virgil-cli.git"
  depends_on "dep" => :build
  depends_on "go" => :build
  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/virgil-cli"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "dep", "ensure"
      system "go", "build", "-o", "virgil"
      system "make", "virgil", "TAGGED_VERSION=v#{version}"
      bin.install "virgil"
    end
  end

  test do
    result = %x(`virgil pure keygen`)
    assert_true result.start_with?("SK.1.")
  end
end

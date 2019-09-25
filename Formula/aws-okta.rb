class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.24.0.tar.gz"
  sha256 "c7a60f5f8c20c88ab8dbcb4f3e1efe7615d7c8c118163b5728845885b3a4feb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "cea284dad30cc55b29c37d643cdf75ef386a24999b99e19d69ca46ab3fc0b007" => :mojave
    sha256 "8707c234fda13112203cee0e09d92f5da916ef0c5f618de190efe7f1f89d6bb4" => :high_sierra
    sha256 "3c64d1756d1cdd3325660d86464af59c19e778b91abfddbf2fd7e8981fdc135d" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/segmentio/aws-okta").install buildpath.children
    cd "src/github.com/segmentio/aws-okta" do
      system "govendor", "sync"
      system "go", "build", "-ldflags", "-X main.Version=#{version}"
      bin.install "aws-okta"
      prefix.install_metafiles
    end
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/aws-okta --backend file add") do |input, output, _pid|
      output.puts "organization\n"
      input.gets
      output.puts "us\n"
      input.gets
      output.puts "fakedomain.okta.com\n"
      input.gets
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end

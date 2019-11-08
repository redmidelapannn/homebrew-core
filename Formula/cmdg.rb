class Cmdg < Formula
  desc "Gmail CLI - Copyright Thomas Habets thomas@habets.se 2019"
  homepage "https://github.com/ThomasHabets/cmdg"
  url "https://github.com/ThomasHabets/cmdg/archive/cmdg-1.00.tar.gz"
  sha256 "4a723a812eae27fac1334e14cfc9b92955e6a3c1c43f1de87aa294d72bb7dc25"
  bottle do
    cellar :any_skip_relocation
    sha256 "9782dd735edd897f92e1cc07bf1c60d5bb0057b547723e40423346f09d6288b5" => :catalina
    sha256 "2890e999c103c026f4e89d4088b44eaa3bf935366c3c17f58401d03104d5b53a" => :mojave
    sha256 "f2e0ae928a8c65917992b2e4d7b3ee5c6dc865ba9a9e99cbb015027f79763d6c" => :high_sierra
  end

  depends_on "go"
  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/mattn/go-runewidth"
    system "go", "get", "github.com/pkg/errors"
    system "go", "get", "github.com/sirupsen/logrus"
    system "go", "get", "golang.org/x/crypto/ssh/terminal"
    system "go", "get", "golang.org/x/oauth2"
    system "go", "get", "golang.org/x/text/encoding"
    system "go", "get", "google.golang.org/api/gmail/v1"
    system "go", "get", "github.com/ThomasHabets/cmdg/cmd/cmdg"
    system "go", "build", "github.com/ThomasHabets/cmdg/cmd/cmdg"
    bin.install "./cmdg" => "cmdg"
  end

  test do
    system "#{bin}/cmdg", "--help"
  end
end

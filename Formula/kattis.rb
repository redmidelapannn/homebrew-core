class Kattis < Formula
  desc "Command-line submission tool for the Kattis online judge"
  homepage "https://open.kattis.com/"
  url "https://open.kattis.com/download/submit.py?#{version}"
  version "40d54c"
  sha256 "e0077380c6e479c03c631caf652f02e0d85d5ae288b4f4a79c285bb22f3bc3f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "54800fd86d4dbd8f9f5f1ef658ff71cfde2cd8c0f79aee668910052a9bcde7b4" => :high_sierra
    sha256 "54800fd86d4dbd8f9f5f1ef658ff71cfde2cd8c0f79aee668910052a9bcde7b4" => :sierra
    sha256 "54800fd86d4dbd8f9f5f1ef658ff71cfde2cd8c0f79aee668910052a9bcde7b4" => :el_capitan
  end

  def install
    bin.install "submit.py" => "kattis"
  end

  test do
    system "#{bin}/kattis", "-h"
  end
end

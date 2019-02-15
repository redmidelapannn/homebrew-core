class AwsSessionManagerPlugin < Formula
  desc "Official Amazon AWS session manager plugin"
  homepage "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/1.0.37.0/mac/sessionmanager-bundle.zip"
  version "1.0.37.0"
  sha256 "4c04afb88081a23984cea5ca9fe2060045f8f4c96785e2771585b797631b6f16"

  bottle do
    cellar :any_skip_relocation
    sha256 "4befe7a18d211169b5c9b1e1f9462be46ffb4d7d4d0aa9d1bb649daecd651e39" => :mojave
    sha256 "4befe7a18d211169b5c9b1e1f9462be46ffb4d7d4d0aa9d1bb649daecd651e39" => :high_sierra
    sha256 "28f524d12e19a4f933476fb6bae4761e92a1dde27b6485f6378eb82b79bbf33e" => :sierra
  end

  def install
    bin.install "bin/session-manager-plugin"
    prefix.install "seelog.xml.template"
    doc.install %w[LICENSE VERSION]
  end

  def caveats; <<~EOS
    The "seelog.xml.template" has been installed to:
      #{HOMEBREW_PREFIX}/seelog.xml.template
  EOS
  end

  test do
    system "session-manager-plugin"
  end
end

class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.0.38-1.tar.gz"
  version "3.0.38"
  sha256 "5adbbe8145e970de1d516a404554e887806d31382de81d290e71fe270183c28a"

  bottle do
    cellar :any_skip_relocation
    sha256 "05ca8c64a806b173e052a6a75a1ee586ede3cc853ab8d2bd82bdffc818501e05" => :catalina
    sha256 "05ca8c64a806b173e052a6a75a1ee586ede3cc853ab8d2bd82bdffc818501e05" => :mojave
    sha256 "05ca8c64a806b173e052a6a75a1ee586ede3cc853ab8d2bd82bdffc818501e05" => :high_sierra
  end

  def install
    bin.install("inxi")
    man.install("inxi.1")

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install(file)
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    assert_match version.to_str, inxi_output

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end

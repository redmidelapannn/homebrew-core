class ApkPatchSizeEstimator < Formula
  desc "Estimates the size of Play patches / gzipped APKs."
  homepage "https://github.com/googlesamples/apk-patch-size-estimator"
  url "https://github.com/googlesamples/apk-patch-size-estimator/archive/0.2.tar.gz"
  sha256 "cbab54effbbbb2abf3ddb58cf004e8ee0e38b520fbc5266f08a5fd6a8cf9c9ff"
  bottle do
    cellar :any_skip_relocation
    sha256 "1579c9bf188c07f826c68993ce90e6e9cef810615593d89b6155f60c081de3f1" => :sierra
    sha256 "4e5748ff75ed106fa79156bc26e2d9e1ac7db49b6e2879a057f62e26ea0c418b" => :el_capitan
    sha256 "4e5748ff75ed106fa79156bc26e2d9e1ac7db49b6e2879a057f62e26ea0c418b" => :yosemite
  end

  depends_on "bsdiff"

  def install
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.py") do |script|
      bin.install_symlink script => File.basename(script, ".py").tr("_", "-")
    end
  end

  test do
    assert_match /^usage: apk-patch-size-estimator/, shell_output("#{bin}/apk-patch-size-estimator --help").strip
  end
end

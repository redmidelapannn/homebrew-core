class Upspin < Formula
  desc "Upspin: A framework for naming everyone's everything"
  homepage "https://upspin.io/"
  url "https://upspin.io/dl/upspin.darwin_amd64.tar.gz"
  version "63f1073c7a3a0fe6162849630916771c15ed80e9"
  sha256 "65957b27817f003587267af25b8cc2c665aad4d63fc62bf7c59158ac4796ed9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b095a8b4c9fb9f3c2c59e2f8d2e2b3612e89a844963e6ef07bd7fd1988f5c1e1" => :high_sierra
    sha256 "b095a8b4c9fb9f3c2c59e2f8d2e2b3612e89a844963e6ef07bd7fd1988f5c1e1" => :sierra
    sha256 "b095a8b4c9fb9f3c2c59e2f8d2e2b3612e89a844963e6ef07bd7fd1988f5c1e1" => :el_capitan
  end

  def install
    bin.install "cacheserver"
    mv bin/"cacheserver", bin/"upspin-cacheserver"
    bin.install "upspin"
    bin.install "upspin-audit"
    bin.install "upspin-ui"
    bin.install "upspinfs"
  end

  test do
    assert_match /^Build time:\s.*UTC$/, pipe_output("#{bin}/upspin --version")
  end
end

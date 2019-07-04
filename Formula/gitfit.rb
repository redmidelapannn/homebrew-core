class Gitfit < Formula
  desc "Git extensions to provide high-level repository operations for Git Feature Branch Workflow."
  homepage "https://cjpatoilo.com/gitfit"
  url "https://github.com/cjpatoilo/gitfit/archive/v0.5.3.zip"
  sha256 "4b8fe1e7a451d140462ea983408859160ec0bff35055f484cb1656c078ba04f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "306585bc997fc6e4b2fd42d404e5d66917f01d1a7646576c6441c983f696ea44" => :mojave
    sha256 "306585bc997fc6e4b2fd42d404e5d66917f01d1a7646576c6441c983f696ea44" => :high_sierra
    sha256 "d9fe581d07345635e4bc1bc56a42e119b23a8b990a9dd9a2a33b5fae6f3614e9" => :sierra
  end

  depends_on "git"

  def install
    bin.install "gitfit"
  end

  test do
    system bin/"gitfit", "init"
    system bin/"gitfit", "start", "test"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"git", "add", "haunted", "house"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    system bin/"gitfit", "finish", "v1.0.0"
  end
end

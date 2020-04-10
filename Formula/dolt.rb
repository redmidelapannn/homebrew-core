class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.15.2.tar.gz"
  sha256 "4ad1a89bb76dec9bb3863c1dcbf200d68e02fa2c5b2f68f1e952e64a3fc9b16b"

  bottle do
    cellar :any_skip_relocation
    sha256 "55a013cef8d31999c8952873384f4581bbdeef902d0b5a02fd5fc24afc04cce9" => :catalina
    sha256 "f46f3a5a97954b0689aabf7bfed5c43915aaf11053af70b5420a5a59890ba63f" => :mojave
    sha256 "f3ac4eb10b1822e7e5a738eb2f5a4105c4428c2d3cede90e059c029b5bf2702e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end

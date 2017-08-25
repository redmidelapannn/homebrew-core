class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.4.1.tar.gz"
  sha256 "56f99f06fb1fde0c0f5d92261032fca1eeba1e23d224b614da9fffbcb22ef442"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "381c5d34efd4c3f70a3be7fb0a42dd1518efa32d0b0329086c27963c011fb7e9" => :sierra
    sha256 "746aa199f3181635b7a7956dc36e16e2dcfa9b5b728d7746ed8d0885867218a9" => :el_capitan
    sha256 "4f930b5307f7be5f593949726a854ac6f1fdba4809d34a8c601cf285b455acd7" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.5.0-beta.1.tar.gz"
    sha256 "fd95787065f1059e8c29801e3f8bef3661fa37ed8bf39e2f379280e52433e37e"

    # Minor problem with a missing public import, fixed in master,
    # fix should be in next beta
    patch do
      url "https://github.com/dlang/dub/pull/1221.patch?full_index=1"
      sha256 "40b38363c91f6aa1440d81f2b3cb29f0bf8aab3b8e945503437f271d290f4344"
    end
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end

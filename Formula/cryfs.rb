class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.9/cryfs-0.9.9.tar.xz"
  sha256 "aa8d90bb4c821cf8347f0f4cbc5f68a1e0f4eb461ffd8f1ee093c4d37eac2908"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3cef352ad90b1f228e5e611e0ecc3d15b89b7bbae39ee98b8927b03a527c18d4" => :mojave
    sha256 "19a5ef441e267e52d660880b03e4a9c86db85fcb188fc15a113f6cce161ab068" => :high_sierra
    sha256 "9aaaad8f5c77cb57361429c3f5d6f792af0710453d6c06627a9571c1b3dd1e95" => :sierra
  end

  head do
    url "https://github.com/cryfs/cryfs.git", :branch => "develop", :shallow => false
    depends_on "libomp"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cryptopp"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    if build.head?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    system "cmake", ".", *configure_args, *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"
    assert_match "CryFS", shell_output("#{bin}/cryfs", 10)
  end
end

class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"

  bottle do
    rebuild 1
    sha256 "280057ce5a34a811ca7bec7b2a74b6e15f1c58df3fc85ec0419de8108c3203d7" => :sierra
    sha256 "0af8d5353a48b6f35b1304bbd63e9572c9c908ea1b8041560476b17f6573d33b" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on :mpi => [:cc, :cxx]

  def install
    system "2to3", "--write", "--fix=print", "SConstruct"

    # Don't install 'CVS' folders from tarball
    rm_rf "include/CVS"
    rm_rf "include/tools/CVS"
    scons "-Q", "mode=release"
    prefix.install "lib", "include"
  end
end

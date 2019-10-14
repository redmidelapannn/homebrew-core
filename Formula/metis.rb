class Metis < Formula
  desc "Programs that partition graphs and order matrices"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"
  revision 1

  bottle do
    cellar :any
    sha256 "1b100a3490e7c1963fa810d2a3367ace9220913d583feb5457d331e252471661" => :catalina
    sha256 "96a1efaf22a2dc560f0e49e32adadf2698f7d27d56a106ba950f35eb4a352b03" => :mojave
    sha256 "71dc9c65c2ae7a23063121ee0d1e389b4ae9ea40be84e0ff7168aad11b945b74" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args + %W[
        -DSHARED=ON
        -DOPENMP=ON
        -DGKLIB_PATH=#{buildpath}/GKlib
        -DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -Xlinker\ -lomp
        -DOpenMP_C_LIB_NAMES=omp
        -DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -Xlinker\ -lomp
        -DOpenMP_CXX_LIB_NAMES=omp
        -DOpenMP_omp_LIBRARY=-lomp
      ]
      system "make", "install"
    end

    pkgshare.install "graphs"
  end

  test do
    ["4elt", "copter2", "mdual"].each do |g|
      cp pkgshare/"graphs/#{g}.graph", testpath
      system "#{bin}/graphchk", "#{g}.graph"
      system "#{bin}/gpmetis", "#{g}.graph", "2"
      system "#{bin}/ndmetis", "#{g}.graph"
    end
    cp [pkgshare/"graphs/test.mgraph", pkgshare/"graphs/metis.mesh"], testpath
    system "#{bin}/gpmetis", "test.mgraph", "2"
    system "#{bin}/mpmetis", "metis.mesh", "2"
  end
end

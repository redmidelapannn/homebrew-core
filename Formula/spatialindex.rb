class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.github.io"
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha256 "7caa46a2cb9b40960f7bc82c3de60fa14f8f3e000b02561b36cbf2cfe6a9bfef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fdf8890d365c7d3337726c5d1e570bd6c12b1e62a017670fe8533cffc717944c" => :el_capitan
    sha256 "43e4faa0853c910f27e149da03f7b36bc4938a22e4575928b6671155906b61c9" => :yosemite
    sha256 "fd7c859e2b5cb9554f7aca60c4fedee2e98f4363713674cb2e32bd116e96e138" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # write out a small program which inserts a fixed box into an rtree
    # and verifies that it can query it
    (testpath/"test.cpp").write <<-EOS.undent
    #include <spatialindex/SpatialIndex.h>

    using namespace std;
    using namespace SpatialIndex;

    class MyVisitor : public IVisitor {
    public:
        vector<id_type> matches;

        void visitNode(const INode& n) {}
        void visitData(const IData& d) {
            matches.push_back(d.getIdentifier());
        }
        void visitData(std::vector<const IData*>& v) {}
    };


    int main(int argc, char** argv) {
        IStorageManager* memory = StorageManager::createNewMemoryStorageManager();
        id_type indexIdentifier;
        RTree::RTreeVariant variant = RTree::RV_RSTAR;
        ISpatialIndex* tree = RTree::createNewRTree(
            *memory, 0.5, 100, 10, 2,
            variant, indexIdentifier
        );
        /* insert a box from (0, 5) to (0, 10) */
        double plow[2] = { 0.0, 0.0 };
        double phigh[2] = { 5.0, 10.0 };
        Region r = Region(plow, phigh, 2);

        std::string data = "a value";

        id_type id = 1;

        tree->insertData(data.size() + 1, reinterpret_cast<const byte*>(data.c_str()), r, id);

        /* ensure that (2, 2) is in that box */
        double qplow[2] = { 2.0, 2.0 };
        double qphigh[2] = { 2.0, 2.0 };
        Region qr = Region(qplow, qphigh, 2);
        MyVisitor q_vis;

        tree->intersectsWithQuery(qr, q_vis);

        return (q_vis.matches.size() == 1) ? 0 : 1;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end

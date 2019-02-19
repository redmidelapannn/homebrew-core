class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.org/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/1.9.0/spatialindex-src-1.9.0.tar.gz"
  sha256 "52d6875deea12f88e6918d192cbfd38d6e78d13f84e1fd10cca66132fa063941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "07022cdc7ad9a08019745a57cd2df2e0ab19b0426208c46ea2dc311c37c07b49" => :mojave
    sha256 "169da7e5119c4836fcd9437d9903142d3ccd07eb7eaf18306e744c6f3f4c7613" => :sierra
  end

  def install
    ENV.cxx11

    ENV.append "CXXFLAGS", "-std=c++11"

    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # write out a small program which inserts a fixed box into an rtree
    # and verifies that it can query it
    (testpath/"test.cpp").write <<~EOS
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end

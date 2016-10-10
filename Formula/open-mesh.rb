class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/5.1/OpenMesh-5.1.tar.gz"
  sha256 "643262dec62d1c2527950286739613a5b8d450943c601ecc42a817738556e6f7"
  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2f3c139b8975dfbe8e1b61fde48104539824bc7254dfaf7d717de92abea126f" => :sierra
    sha256 "406bc5d8677475b97e9ec47a4af23b22e4d144a90629b0c773ac3486b78a09c1" => :el_capitan
    sha256 "36ba7271d7f2a6c0ad401c48acbdfc2bb56c433672e0881e3f56c65253e80715" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_APPS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <iostream>
    #include <OpenMesh/Core/IO/MeshIO.hh>
    #include <OpenMesh/Core/Mesh/PolyMesh_ArrayKernelT.hh>
    typedef OpenMesh::PolyMesh_ArrayKernelT<>  MyMesh;
    int main()
    {
        MyMesh mesh;
        MyMesh::VertexHandle vhandle[4];
        vhandle[0] = mesh.add_vertex(MyMesh::Point(-1, -1,  1));
        vhandle[1] = mesh.add_vertex(MyMesh::Point( 1, -1,  1));
        vhandle[2] = mesh.add_vertex(MyMesh::Point( 1,  1,  1));
        vhandle[3] = mesh.add_vertex(MyMesh::Point(-1,  1,  1));
        std::vector<MyMesh::VertexHandle>  face_vhandles;
        face_vhandles.clear();
        face_vhandles.push_back(vhandle[0]);
        face_vhandles.push_back(vhandle[1]);
        face_vhandles.push_back(vhandle[2]);
        face_vhandles.push_back(vhandle[3]);
        mesh.add_face(face_vhandles);
        try
        {
        if ( !OpenMesh::IO::write_mesh(mesh, "triangle.off") )
        {
            std::cerr << "Cannot write mesh to file 'triangle.off'" << std::endl;
            return 1;
        }
        }
        catch( std::exception& x )
        {
        std::cerr << x.what() << std::endl;
        return 1;
        }
        return 0;
    }

    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lOpenMeshCore
      -lOpenMeshTools
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

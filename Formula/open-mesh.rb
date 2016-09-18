class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/6.2/OpenMesh-6.2.tar.gz"
  sha256 "570b5b2d3b949050d9628367268c495e87b3dc59f18a07c8037449356fe40374"
  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "c37b54e7ddcc673d7e3eb87f4f124a9de62af8637dc32b8ba7783044c883eee2" => :sierra
    sha256 "0cd078576f14a5afc3be66589821635fed280370a9ebac0cec5351537ca66a73" => :el_capitan
    sha256 "684dae86c09f1b86823b3ba55849bf406356979ba5361af11822a14a3d907a85" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt" => :optional

  option "without-python", "Build without python 2 support"
  depends_on "boost-python"

  def install
    mkdir "build" do
      args = std_cmake_args

      if build.with? "qt"
        args << "-DBUILD_APPS=ON"
      else
        args << "-DBUILD_APPS=OFF"
      end

      if build.without? "python"
        args << "-DOPENMESH_BUILD_PYTHON_BINDINGS=OFF"
      else
        args << "-DOPENMESH_BUILD_PYTHON_BINDINGS=ON"
      end

      inreplace "#{buildpath}/src/Python/CMakeLists.txt", "${ACG_PROJECT_LIBDIR}/python", "${ACG_PROJECT_LIBDIR}/python2.7/site-packages"

      system "cmake", "..", *args
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
    system "python -c 'import openmesh;'"
  end
end

*** Settings ***
Documentation    Test Seller Center REST API
...    Add test cases for Add New Product

Resource    ../../resources.robot
Resource    ../../Common/Utils.robot

Test Setup    Init Test Step List
Suite Setup    Suite Setup    ${FOLDER_ADD_PRODUCT}    ${TEST_CASE_FOLDER}

*** Variables ***
${ISSUE_KEY}=    ${null}


*** Test Cases ***  

Delete Old Test Case
    Check And Delete All Test Cases From Folder    ${FOLDER_ADD_PRODUCT}
    
TC01_Add product without input data
      Add Test Step    Put a product without input any data     The product is failed to add
      Complete Test Case    ${FOLDER_ADD_PRODUCT}    ${ISSUE_KEY} 
        
TC02_Input all required data but product name is empty
      Add Test Step    Input all required data except the product name     The product is failed to add
      Complete Test Case    ${FOLDER_ADD_PRODUCT}    ${ISSUE_KEY}     

TC03_Input all required data but product name contains space only
      Add Test Step    Input all required data but the product name contains space only     The product is failed to add
      Complete Test Case    ${FOLDER_ADD_PRODUCT}    ${ISSUE_KEY}
           
TC04_Input all required data but product name is over max length
      Add Test Step    Input all required data but the characters of product name is over max lenth     The product is failed to add
      Complete Test Case    ${FOLDER_ADD_PRODUCT}    ${ISSUE_KEY}    

TC05_Input all required data and product name is max length
      Add Test Step    Input all required data and the characters of product name is max lenth     The product is successful to add
      Complete Test Case    ${FOLDER_ADD_PRODUCT}    ${ISSUE_KEY}    
      
# TC06_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa tiếng việt có dấu
# TC07_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa Asean language
# TC08_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa ký tự space ở đầu
# TC09_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa ký tự space ở cuối
# TC10_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa chữ in hoa
# TC11_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa chữ in thường
# TC12_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Tên sản phẩm chứa số
# TC13_Kiểm tra việmới khi chưa đầy đủ các thông tin bắt buộc -  Danh mục trống
# TC14_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Danh mục thuộc danh mục cha cấp 1
# TC15_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Danh mục thuộc danh mụcấp cuối cùng
# TC16_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Danh mục thuộc danh mục cấp ở giữa
# TC17_Kiểm tra việmới khi chưa đầy đủ các thông tin bắt buộc -  Thương hiệu trống
# TC18_Kiểm tra việmới khi chưa đầy đủ các thông tin bắt buộc -  Đơn vị tính trống
# TC19_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Đơn vị đo lường mua hàng giống đơn vị tính
# TC20_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Đơn vị đo lường mua hàng khác đơn vị tính
# TC21_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Màu sắc trống
# TC22_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc - Model trống
# TC23_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc - Part number trống
# TC24_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc - Barcode trống
# TC25_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Loại sản phẩm giữ nguyên giá trị mặc định
# TC26_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Loại sản phẩm khác giá trị mặc định
# TC27_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Mục đích giữ nguyên giá trị mặc định
# TC28_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Mục đích khác giá trị mặc định
# TC29_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa chữ in thường
# TC30_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa tối đa số lượng ký tự đượphép
# TC31_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa chữ in hoa
# TC32_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa ký tự đặc biệt
# TC33_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa ký tự space ở đầu
# TC34_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa ký tự space ở cuối
# TC35_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Model chứa số
# TC36_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa chữ in thường
# TC37_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa chữ in hoa
# TC38_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa tối đa số lượng ký tự đượphép
# TC39_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa ký tự đặc biệt
# TC40_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa ký tự space ở đầu
# TC41_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa ký tự space ở cuối
# TC42_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Part number chứa số
# TC43_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa chữ in thường
# TC44_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa chữ in hoa
# TC45_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa ký tự số
# TC46_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa ký tự đặc biệt
# TC47_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa ký tự space ở đầu
# TC48_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa ký tự space ở cuối
# TC49_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Barcode chứa tiếng việt có dấu
# TC50_Kiểm tra việmới khi chưa nhập đầy đủ thông tin bắt buộc - Thời gian bảo hành trống
# TC51_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự số nguyên
# TC52_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự chữ
# TC53_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự đặc biệt
# TC54_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự space ở đầu
# TC55_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự space ở cuối
# TC56_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự space ở giữa
# TC57_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa tối đa số lượng ký tự đượphép
# TC58_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa quá tối đa số lượng ký tự đượphép
# TC59_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự số thập phân dưới dạng X.Y
# TC60_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự số thập phân dưới dạng X,Y
# TC61_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thời hạn bảo hành chứa ký tự số bắt đầu bằng số 0
# TC62_Kiểm tra việmới khi chưa đầy đủ các thông tin bắt buộc - Ghi chú bảo hành chứa > tối đa số lượng ký tự đượphép
# TC63_Kiểm tra việmới khi chưa đầy đủ các thông tin bắt buộc - Ghi chú bảo hành chứa toàn ký tự space
# TC64_Kiểm tra việmới khi chưa đầy đủ các thông tin không bắt buộc - Ghi chú bảo hành trống
# TC65_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa chữ in hoa
# TC66_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa chữ in thường
# TC67_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa ký tự space ở cuối
# TC68_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa ký tự space ở đầu
# TC69_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa số
# TC70_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa tiếng việt có dấu
# TC71_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Ghi chú bảo hành chứa tối đa số lượng ký tự đượphép
# TC72_Kiểm tra việmới khi chưa nhập đầy đủ thông tin bắt buộc - Thuế mua vào trống
# TC73_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự chữ
# TC74_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự space ở cuối
# TC75_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự space ở giữa
# TC76_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự space ở đầu
# TC77_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự số bắt đầu bằng số 0
# TC78_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự số nguyên
# TC79_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự số thập phân dưới dạng X,Y
# TC80_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự số thập phân dưới dạng X.Y
# TC81_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa ký tự đặc biệt
# TC82_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa quá tối đa số lượng ký tự đượphép
# TC83_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào chứa tối đa số lượng ký tự đượphép
# TC84_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào > 100%
# TC85_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế mua vào = 0
# TC86_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra = 0
# TC87_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra > 100%
# TC88_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự chữ
# TC89_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự space ở cuối
# TC90_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự space ở giữa
# TC91_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự space ở đầu
# TC92_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự số bắt đầu bằng số 0
# TC93_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự số nguyên
# TC94_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự số thập phân dưới dạng X,Y
# TC95_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự số thập phân dưới dạng X.Y
# TC96_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa ký tự đặc biệt
# TC97_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa quá tối đa số lượng ký tự đượphép
# TC98_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Thuế bán ra chứa tối đa số lượng ký tự đượphép
# TC99_Kiểm tra việmới khi chưa nhập đầy đủ thông tin bắt buộc - Thuế bán ra trống
# TC100_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc -  Khối lượng trống
# TC101_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự chữ
# TC102_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự space ở cuối
# TC103_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự space ở giữa
# TC104_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự space ở đầu
# TC105_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự số bắt đầu bằng số 0
# TC106_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự số nguyên
# TC107_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự số thập phân dưới dạng X,Y
# TC108_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự số thập phân dưới dạng X.Y
# TC109_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa ký tự đặc biệt
# TC110_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa quá tối đa số lượng ký tự đượphép
# TC111_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Khối lượng chứa tối đa số lượng ký tự đượphép
# TC112_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc -  Kích thước chiều dài trống
# TC113_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự chữ
# TC114_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự space ở cuối
# TC115_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự space ở giữa
# TC116_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự space ở đầu
# TC117_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự số bắt đầu bằng số 0
# TC118_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự số nguyên
# TC119_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự số thập phân dưới dạng X,Y
# TC120_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự số thập phân dưới dạng X.Y
# TC121_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa ký tự đặc biệt
# TC122_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa quá tối đa số lượng ký tự đượphép
# TC123_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều dài chứa tối đa số lượng ký tự đượphép
# TC124_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc -  Kích thước chiều rộng trống
# TC125_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều rộng chứa ký tự chữ
# TC126_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều rộng chứa ký tự space ở cuối
# TC127_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều rộng chứa ký tự space ở giữa
# TC128_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều rộng chứa ký tự space ở đầu
# TC129_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều rộng chứa ký tự số bắt đầu bằng số 0
# TC130_Kiểm tra việmới khi chưa nhập đầy đủ thông tin không bắt buộc -  Kích thước chiều cao trống
# TC131_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự chữ
# TC132_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự space ở cuối
# TC133_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự space ở giữa
# TC134_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự space ở đầu
# TC135_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự số bắt đầu bằng số 0
# TC136_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự số nguyên
# TC137_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự số thập phân dưới dạng X,Y
# TC138_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự số thập phân dưới dạng X.Y
# TC139_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa ký tự đặc biệt
# TC140_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa quá tối đa số lượng ký tự đượphép
# TC141_Kiểm tra việmới khi đã nhập toàn bộ thông tin - Kích thước chiều cao chứa tối đa số lượng ký tự đượphép

 
    


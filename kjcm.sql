use classicmodels;

/*
 Tampilkan data pegawai yang memiliki lokasi kantor yang sama dengan anthony
 */
select * from employees where officeCode =
    (select officeCode from employees where firstName = 'Anthony');

/*
 Tampilkan productCode, productName, productLine, dan productVendor untuk produk yang telah dipesan > 1000 buah.
 Tampilkan secara terurut berdasarkan productCode.
 */
select p.productCode, p.productName, p.productLine, p.productVendor from products as p
    join orderdetails as od on p.productCode = od.productCode
    group by od.productCode
    having sum(od.quantityOrdered) > 1000
    order by od.productCode asc;
# Versi menggunakan subquery
select productCode, productName, productLine, productVendor from products
    where productCode in
        (select productCode from orderdetails
            group by productCode
            having sum(quantityOrdered) > 1000
            order by productCode asc);

/*
 Tampilkan kategori statistik total tagihan order beserta nominalnya
 */
select 'Minimal' as 'Kategori Tagihan', min(total) as 'Total Tagihan' from (
    select sum(quantityOrdered * priceEach) as total from orderdetails
        group by orderNumber order by sum(quantityOrdered * priceEach) asc
) as total_table
union
select 'Maksimal' as 'Kategori Tagihan', max(total) as 'Total Tagihan' from (
    select sum(quantityOrdered * priceEach) as total from orderdetails
        group by orderNumber order by sum(quantityOrdered * priceEach) asc
) as total_table
union
select 'Rata-rata' as 'Kategori Tagihan', avg(total) as 'Total Tagihan' from (
    select sum(quantityOrdered * priceEach) as total from orderdetails
        group by orderNumber order by sum(quantityOrdered * priceEach) asc
) as total_table;

/*
 Lakukan select data customers, dimana customer berasal dari kota 'Nantes'
 */
select * from customers where city = 'Nantes';

/*
 Berapakah rata rata dari buyprice yang ada pada tabel products?
*/
select avg(buyPrice) as 'Rata-rata Buy Price' from products;

/*
 List nama produk, deskripsi produk, dan harga produk dimana
 harga produk diurutkan dari yang paling kecil
 */
select productName, productDescription, buyPrice from products
    order by buyPrice asc;

/*
 List nama customer, citym dan postalCode dimana postalCode sama dengan 44000
 */
select customerName, city, postalCode from customers
    where postalCode = 44000;

/*
 List nomor order, status order, dan comments order, dimana status order
 adalah On Hold, dan Disputed
 */
select orderNumber, status, comments from orders
    where status = 'On Hold' or status = 'Disputed';

/*
 Siapa karyawan yang melapor ke MurphyDiane
 */
select * from employees where reportsTo =
    (select employeeNumber from employees where lastName = 'Murphy' and firstName = 'Diane');

/*
 Tampilkan nama produk classic cars yang harga belinya diatas rata-rata
 */
select productName from products where buyPrice >
    (select avg(buyPrice) from products) and productLine = 'Classic Cars';

/*
 Tampilkan rata-rata dari penjualan perbulan tertinggi dan terendah di tahun 2003
 */
select 'Tertinggi' as 'Kategori', `Bulan`, max(`Rata-rata`) as 'Penjualan' from
    (select month(orderDate) as 'Bulan', avg(quantityOrdered * priceEach) as 'Rata-rata' from orderdetails
        join orders using (orderNumber)
        where year(orderDate) = 2003
        group by month(orderDate)
        order by `Rata-rata` desc) as avg_table
union
select 'Terendah' as 'Kategori', `Bulan`, min(`Rata-rata`) as 'Penjualan' from
    (select month(orderDate) as 'Bulan', avg(quantityOrdered * priceEach) as 'Rata-rata' from orderdetails
        join orders using (orderNumber)
        where year(orderDate) = 2003
        group by month(orderDate)
        order by `Rata-rata` asc) as avg_table;

/*
 Tampilkan data customerName, orderDate, productLine, dan textDescription
 dimana customerNumber = 161
 */
select customerName, orderDate, productLine, textDescription from customers
    join orders using (customerNumber)
    join orderdetails using (orderNumber)
    join products using (productCode)
    join productlines using (productLine)
    where customerNumber = 161;

/*
 Tampilkan productLine, dan jumlah dari quantityOrdered per productLine
 */
select productLine, sum(quantityOrdered) as 'Jumlah Order' from orderdetails
    join products using (productCode)
    group by productLine;

/*
 Tampilkan data nama customer, alamat 1 yang berakhiran 86, tanggal order, dan
 status order selain 'Shipped'
 */
select customerName, addressLine1, orderDate, status from customers
    join orders using (customerNumber)
    where addressLine1 like '%86' and status != 'Shipped';

/*
 Tampilkan data productLine, maksimal dari jumlah order, dan rata-rata dari harga
 orderan berdasarkan productLine
 */
select productLine, max(quantityOrdered) as jumlah_order, avg(quantityOrdered * priceEach) as harga_order from orderdetails
    join products using (productCode) group by productLine;

/*
 Tampilkan nama customer, nomor telepon customer, dan sales dari customer tersebut
 dan data diurutkan dari yang terkecil ke terbesar berdasarkan nomor employee
 */
select customerName, phone, salesRepEmployeeNumber from customers
    join employees on salesRepEmployeeNumber = employeeNumber
    order by employeeNumber asc;

/*
 Tampilkan product yang memiliki range harga antara 40 sd 60, serta jumlah orderan
 dari product tersebut. Urutkan range harga dari terbesar ke terkecil
 */
select productName, buyPrice, sum(quantityOrdered) as jumlah_order from products
    join orderdetails using (productCode)
    where buyPrice between 40 and 60
    group by productName
    order by buyPrice desc;

/*
 Tampilkan productLine serta deskripsinya, dan rata-rata jumlah quantityInStock
 berdasarkan productLine, dan rata-ratanya > 3000
 */
select productLine, textDescription, avg(quantityInStock) as rata_rata from productlines
    join products using (productLine)
    where quantityInStock > 3000
    group by productLine;

/*
 Customers ingin melihat product yang memiliki harga antara 40 sd 60.
 Sintaks yang tepat untuk memperoleh data tersebut adalah
 */
select productName, buyPrice from products
    where buyPrice between 40 and 60;

/*
 List data customer yang tinggal di kota Nantes, Las Vegas, dan Melbourne, dengan memiliki
 credit limit antara 20k sd 60k
 */
select * from customers
    where city in ('Nantes', 'Las Vegas', 'Melbourne') and creditLimit between 20000 and 60000;

/*
 Customer ingin melihat product yang memiliki range harga antara 40 sd 60
 urutkan dari harga yang paling mahal
 */
select productName, buyPrice from products
    where buyPrice between 40 and 60
    order by buyPrice desc;

/*
 Tampilkan data kode product, nama product, productLine minimum dan maksimum
 dari qualityInStock berdasarkan productName menggunakan groupby
 */
select productCode, productName, productLine, min(quantityInStock) as min_stock, max(quantityInStock) as max_stock from products
    group by productName;

/*
 Tampilkan data kode product, nama product, productLine, rata-rata dari quantityInStock berdasarkan
 productName menggunakan groupby, dimana nilai rata-rata > 3000
 */
select productCode, productName, productLine, avg(quantityInStock) as rata_rata from products
    group by productName
    having rata_rata > 3000;

/*
 Tampilkan daftar nomor order, dan berapa jenis product yang ada pada order tersebut,
 Terurut berdasarkan nomor order
 */
select orderNumber, count(distinct productCode) as jumlah_product from orderdetails
    group by orderNumber
    order by orderNumber;

/*
 Tampilkan jumlah customers yang ditangani sales representative setiap office
 */
select officeCode, count(distinct customerNumber) as jumlah_customer from customers
    join employees on salesRepEmployeeNumber = employeeNumber
    group by officeCode;

/*
 Tampilkan data produk (productCode, productName, quantityInStock, buyPrice) dengan vendor
 Welly Diecast Productions
 */
select productCode, productName, quantityInStock, buyPrice from products
    where productVendor = 'Welly Diecast Productions';

/*
 Tampilkan nama customer dan jumlah order yang pernah dilakukannya
 */
select customerName, count(orderNumber) as jumlah_order from customers
    join orders using (customerNumber)
    group by customerName;

/*
 Tampilkan daftar nomor order dan berapa jumlah item yang ada pada
 order tersebut, urutkan berdasarkan nomor order
 */
select orderNumber, count(orderNumber) as jumlah_item from orderdetails
    group by orderNumber
    order by orderNumber asc;

/*
 Tampilkan gabungan nama depan, nama belakang sales representative
 beserta jumlah customernya yang ditangani oleh sales representative tersebut
 */
select concat((firstName), ' ', (lastName)) as nama_sales, count(customerNumber) as jumlah_customer from employees
    join customers on employeeNumber = salesRepEmployeeNumber
    group by employeeNumber;

/*
 Tampilkan informasi produk yang productLinenya adalah vintage cars
 dan memiliki harga beli < 50
 */
select productCode, productName, quantityInStock, buyPrice from products
    where productLine = 'Vintage Cars' and buyPrice < 50;

/*
 Tampilkan harga beli product yang tertinggi, terendah, dan rata-ratanya. Tampilkan dalam satu
 query dan lengkapi dengan informasi kategorinya (Maksimal, Minimal, Rata-rata. Tampilkan dalam
 baris yang berbeda untuk setiap kategori
 */
select 'Maksimal' as kategori, max(buyPrice) as harga_beli from products
    union
select 'Minimal' as kategori, min(buyPrice) as harga_beli from products
    union
select 'Rata-rata' as kategori, avg(buyPrice) as harga_beli from products;

/*
 Tampilkan informasi produk dengan harga beli kurang dari 500 dollar dan
 jumlah stonya lebih besar dari 7000. Terurut berdasarkan productCode
 */
select productCode, productName, quantityInStock, buyPrice from products
    where buyPrice < 500 and quantityInStock > 7000
    order by productCode;

/*
 Tampilkan informasi mengenai productCode, status, orderDate yang memiliki harga
 (quantityOrdered * priceEach) lebih besar dari harga terbesar (quantityOrdered * priceEach)
 pada productCode S18_2325
 */
select productCode, status, orderDate from orders
    join orderdetails using (orderNumber)
    where quantityOrdered * priceEach > (
        select max(quantityOrdered * priceEach) from orderdetails
            where productCode = 'S18_2325');

/*
 Tampilkan data employee: employeeNumber, FullName karyawan (gabungan firstname dan lastname),
 jobTitle, officeCode, beserta alamat kantornya masing-masing (gabungan dari semua kolom terkait
 alamat) officeCode. Tampilkan terurut dari employeeNumber paling besar
 */
select employeeNumber, concat(firstName, ' ', lastName) as full_name, jobTitle, officeCode, concat(addressLine1, ', ', addressLine2, ', ', city, ', ', state, ', ', country) as alamat from employees
    join offices using (officeCode)
    order by employeeNumber desc;

/*
 Tampilkan daftar nomor order dan berapa jumlah item yang ada pada order tersebut
 Terurut berdasarkan jumlah item terbanyak
 */
select orderNumber, count(productName) as jumlah_item from orderdetails
    join products using (productCode)
    group by orderNumber
    order by jumlah_item desc;

/*
 Tampilkan employee_id dan nama employee dengan nama managernya
 */
select e.employeeNumber as id_imployee, m.employeenumber as id_manager, concat(e.firstName, ' ', e.lastName) as nama_employee, concat(m.firstName, ' ', m.lastName) as nama_manager from employees as e
    join employees as m on e.reportsTo = m.employeeNumber;

/*
 Tampilkan gabungan nama depan dan nama belakang sales representative beserta jumlah
 sales ditanganinya
 */
select concat(firstName, ' ', lastName) as nama_sales, count(orderNumber) as jumlah_sales from employees
    join customers on employeeNumber = salesRepEmployeeNumber
    join orders using (customerNumber)
    group by employeeNumber;

/*
 Tampilkan daftar nomor order dan berapa jumlah item yang ada pada order tersebut.
 Terurut berdasarkan nomor order
 */
select orderNumber, count(productName) as jumlah_item from orderdetails
    join products using (productCode)
    group by orderNumber
    order by orderNumber asc;

/*
 Tampilkan productVendor, dan jumlah barang yang tersedia untuk setiap productVendor.
 Terurut berdasarkan productVendor
 */
select productVendor, sum(quantityInStock) as jumlah_barang from products
    group by productVendor
    order by productVendor;

/*
 Tampilkan id karyawan, nama lengkap karyawan (digabung), dan nama lengkap manager (digabung)
 , dari data karyawan yang memiliki manager yang bernama belakang diakhiri dengan huruf y dan
 diurutkan berdasarkan id karyawan dari terbesar
 */
select e.employeeNumber as id_karyawan, concat(e.firstName, ' ', e.lastName) as nama_karyawan, concat(m.firstName, ' ', m.lastName) as nama_manager from employees as e
    join employees as m on e.reportsTo = m.employeeNumber
    where m.lastName like '%y'
    order by id_karyawan desc;

/*
 Tampilkan informasi produk yang productLine nya adalah vintage cars dan memiliki harga beli < 50
 */
select productCode, productName, quantityInStock, buyPrice from products
    where productLine = 'Vintage Cars' and buyPrice < 50;

/*
 Tampilkan customerName, country, credit limit, dan nama lengkap sales representative nya
 (digabung), dimana customer tersebut memiliki credit limit lebih dari 150k. Urutkan berdasarkan
 credit limit dari yang terbesar
 */
select customerName, country, creditLimit, concat(firstName, ' ', lastName) as nama_sales from customers
    join employees on salesRepEmployeeNumber = employeeNumber
    where creditLimit > 150000
    order by creditLimit desc;

/*
 Tampilkan data produk yang dipasok oleh vendor "Welly Diecast Productions"
 dan "Second Gear Diecast"
 */
select productVendor, productName, quantityInStock, buyPrice from products
    where productVendor = 'Welly Diecast Productions' or productVendor = 'Second Gear Diecast';

/*
 Tampilkan informasi nama lengkap employee (digabung), nama lengkap atasan (digabung), officeCode karyawan,
 dan officeCode atasan, dimana karyawan tersebut berada di lokasi kantor yang sama dengan atasannya
 */
select concat(e.firstName, ' ', e.lastName) as nama_karyawan, concat(m.firstName, ' ', m.lastName) as nama_manager, e.officeCode as officeCode_karyawan, m.officeCode as officeCode_manager from employees as e
    join employees as m on e.reportsTo = m.employeeNumber
    where e.officeCode = m.officeCode;

select * from products;
select * from productlines;
select * from orderdetails;
select * from orders;
select * from customers;
select * from employees;
select * from offices;
select * from payments;
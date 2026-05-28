# =====================================================================
# Conditions 章 (https://guides.rubyonrails.org/v8.0/active_record_querying.html#conditions)
# を試すための seed データ。
#
# 冪等性のために destroy_all で全消ししてから入れ直す（練習用 DB だから OK）。
# =====================================================================

ActiveRecord::Base.transaction do
  Order.destroy_all
  Book.destroy_all
  Customer.destroy_all
  Author.destroy_all

  # --------------------------------------------------------- Authors
  matz   = Author.create!(first_name: "Yukihiro", last_name: "Matsumoto")
  dhh    = Author.create!(first_name: "David",    last_name: "Heinemeier")
  sandi  = Author.create!(first_name: "Sandi",    last_name: "Metz")

  # --------------------------------------------------------- Books
  # title はガイドの LIKE 例 (`title LIKE 'Ruby%'`) が当たる/当たらないが
  # 混ざるようにする。
  # status は available 多め / unavailable / out_of_print を混ぜる。
  # out_of_print カラム（boolean）と enum status の `out_of_print` は別物。
  # year_published, views, price を Range / 数値比較で試せるよう分散。
  # created_at は手で過去日付に散らす（Range 例のため）。
  [
    { title: "Ruby Basics",           author: matz,  out_of_print: false, status: :available,    year_published: 2010, views:   42, price:  19.99, created_at: 1.year.ago     },
    { title: "Ruby Deep Dive",        author: matz,  out_of_print: false, status: :available,    year_published: 2018, views:  120, price:  29.99, created_at: 6.months.ago   },
    { title: "Ruby Forgotten Tales",  author: matz,  out_of_print: true,  status: :out_of_print, year_published: 1999, views:    8, price:   9.99, created_at: 3.years.ago    },
    { title: "Rails for Beginners",   author: dhh,   out_of_print: false, status: :available,    year_published: 2014, views:  300, price:  24.99, created_at: 2.months.ago   },
    { title: "Rails Recipes",         author: dhh,   out_of_print: false, status: :unavailable,  year_published: 2016, views:   80, price:  34.99, created_at: 1.month.ago    },
    { title: "Rails Internals",       author: dhh,   out_of_print: true,  status: :out_of_print, year_published: 2008, views:   15, price:  14.99, created_at: 4.years.ago    },
    { title: "POODR",                 author: sandi, out_of_print: false, status: :available,    year_published: 2012, views:  500, price:  39.99, created_at: 3.weeks.ago    },
    { title: "99 Bottles of OOP",     author: sandi, out_of_print: false, status: :available,    year_published: 2017, views:  220, price:  44.99, created_at: 2.weeks.ago    },
    { title: "Practical Refactoring", author: sandi, out_of_print: false, status: :unavailable,  year_published: 2020, views:  130, price:  49.99, created_at: 5.days.ago     },
    { title: "Old Manuscript",        author: sandi, out_of_print: true,  status: :out_of_print, year_published: 1995, views:    3, price:   4.99, created_at: 5.years.ago    },
    { title: "Modern Web Stack",      author: dhh,   out_of_print: false, status: :available,    year_published: 2022, views:  180, price:  27.99, created_at: 2.days.ago     },
    { title: "Yet Another Book",      author: matz,  out_of_print: false, status: :available,    year_published: 2005, views:   60, price:  12.99, created_at: 10.days.ago    }
  ].each do |attrs|
    Book.create!(attrs)
  end

  # --------------------------------------------------------- Customers
  # orders_count を [0, 1, 3, 5, 7, 10] に散らす。
  # ガイドの `where(orders_count: [1, 3, 5])` が 3 件ヒット、
  # `where.not(orders_count: [1, 3, 5])` が 3 件、というふうに学習しやすい。
  customer_specs = [
    { first_name: "Alice",   last_name: "Smith",    orders_count: 0  },
    { first_name: "Bob",     last_name: "Smith",    orders_count: 1  },
    { first_name: "Carol",   last_name: "Johnson",  orders_count: 3  },
    { first_name: "Dave",    last_name: "Williams", orders_count: 5  },
    { first_name: "Eve",     last_name: "Brown",    orders_count: 7  },
    { first_name: "Frank",   last_name: "Smith",    orders_count: 10 }
  ]
  customers = customer_specs.map { |spec| Customer.create!(spec) }

  # --------------------------------------------------------- Orders
  # 各 Customer に orders_count 件ずつ作る（orders_count と実件数が一致）。
  # status を 4 値で循環、created_at を散らして Range 例を試せるように。
  order_statuses = Order.statuses.keys # ["pending", "processing", "shipped", "returned"]
  base_time      = Time.current

  customers.each do |customer|
    customer.orders_count.times do |i|
      Order.create!(
        customer:   customer,
        status:     order_statuses[i % order_statuses.size],
        total:      (10 + i * 7.5).round(2),
        created_at: base_time - (i * 3 + 1).days,
        updated_at: base_time - (i * 3 + 1).days
      )
    end
  end

  puts "---- Seeded ----"
  puts "Authors:   #{Author.count}"
  puts "Books:     #{Book.count}"
  puts "Customers: #{Customer.count}"
  puts "Orders:    #{Order.count}"
end

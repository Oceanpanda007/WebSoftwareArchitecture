from flask import render_template, request

from manage import app, mongo, GIS, EC, NHIS,db


def add_user():
    user_1 = EC(
        first_name="Ama",
        last_name="Yeboah",
        age=22
    )
    user_2 = GIS(
        first_name="Abena",
        last_name="Aba",
        age=23
    )
    user_3 = NHIS(
        first_name="YaKojow",
        last_name="Cladie",
        age=20
    )
    user_4 = {
        "first_name": "James",
        "last_name": "Yaw",
        "age": "21",
    }
    user_5 = GIS(
        first_name="jack",
        last_name="Doe",
        age=18
    )
    user_6 = NHIS(
        first_name="Aku",
        last_name="Fosu",
        age=20
    )

    db.session.add(user_1)  # Adds new User record to database
    db.session.add(user_2)  # Adds new User record to database
    db.session.add(user_3)  # Adds new User record to database
    db.session.add(user_5)  # Adds new User record to database
    db.session.add(user_6)  # Adds new User record to database
    db.session.commit()
    mongo.db.DVLA.insert_one(user_4)


@app.route('/', methods=['GET', 'POST'])
def index():
    errors = []

    add_user()



    if request.method == "POST":
        first_name = request.form['first_name']
        last_name = request.form['last_name']

        if first_name and last_name:
            search_EC = EC.query.filter_by(first_name=first_name, last_name=last_name).all()
            search_GIS = GIS.query.filter_by(first_name=first_name, last_name=last_name).all()
            search_NHIS = NHIS.query.filter_by(first_name=first_name, last_name=last_name).all()

            users = mongo.db.DVLA
            search_DVLA_1 = []
            for c in users.find():
                search_DVLA_1.append(
                    {'first_name': c['first_name'],'last_name': c['last_name'],
                     'age': c['age']})

            search_DVLA = []
            for user in search_DVLA_1:
                if user['first_name'] == first_name and user['last_name'] == last_name:
                    search_DVLA.append(
                        {'first_name': user['first_name'],
                         'last_name': user['last_name'],
                         'age': user['age']})

            return render_template('table.html', search_EC=search_EC, search_GIS=search_GIS,
                                   search_NHIS=search_NHIS, results_DVLA=search_DVLA)
        else:
            errors = {"error": "The request payload is not in JSON format"}

    return render_template('home.html', errors=errors)

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/register',methods=['POST','GET'])
def register():
    if request.method== 'POST':
        FirstName=request.form['FirstName']
        LastName = request.form['LastName']
        Region = request.form['Region']
        Email = request.form['EmailAddress']
        Password = request.form['Password']
        ConfirmPassword=request.form['ConfirmPassword']
    return render_template('register.html')


@app.route('/welcome', methods=['GET', ])
def welcome():
    return render_template('welcome.html')


if __name__ == "__main__":
    app.run()

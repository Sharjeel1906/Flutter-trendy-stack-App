from flask import Flask,request,jsonify
from trendy_questions import StackOverflow

stack_overflow = StackOverflow()
app = Flask(__name__)

@app.route("/get_questions_data",methods=["POST","Get"])
def get_questions():
    return jsonify(stack_overflow.get_trendy_question())


if __name__=="__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
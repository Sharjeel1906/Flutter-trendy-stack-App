import requests
from bs4 import BeautifulSoup
import json

class StackOverflow:
    def __init__(self):
        pass

    def get_trendy_question(self):
        Url = "https://stackoverflow.com/questions?tab=trending&pagesize=50"
        question_list = []
        header = {
            'Accept-Language': "en-US,en;q=0.9",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)"
                          " Chrome/129.0.0.0 Safari/537.36",
        }
        response = requests.get(url=Url, headers=header)
        soup = BeautifulSoup(response.content, "html.parser")
        questions = soup.select('div.s-post-summary.js-post-summary')
        for question in questions:
            votes = question.find('span', class_='s-post-summary--stats-item-number').get_text(strip=True)
            answers = question.find_all('span', class_='s-post-summary--stats-item-number')[1].get_text(strip=True)
            views = question.find_all('span', class_='s-post-summary--stats-item-number')[2].get_text(strip=True)
            title = question.find('h3', class_='s-post-summary--content-title').find('a').get_text(strip=True)
            link = question.find('h3', class_='s-post-summary--content-title').find('a')['href']
            tags_element = question.find('div', class_='s-post-summary--meta-tags')
            tags = []
            if tags_element:
                for tag_item in tags_element.find_all('a', class_='post-tag'):
                    tags.append(tag_item.get_text(strip=True))
            new_question = {
                "Title":title,
                "Link":f"https://stackoverflow.com{link}",
                "Votes":votes,
                "Answers":answers,
                "Views":views,
                "Tags":tags
            }
            question_list.append(new_question)
        if len(question_list)>0:
           return question_list
        else:
            return "Error In Fetching Data From Stack Overflow!"

        with open("stack_overflow.json","w", encoding="utf-8") as f:
            json.dump(question_list, f, indent=4)